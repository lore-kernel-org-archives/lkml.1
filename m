Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXDPGqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXDPGqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXDPGqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:46:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:29199 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbXDPGqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OZXDWp7xq+rAQmh/EvIIREWLaSxxi69dTv8mp6X4cqCu0wWF/yYITbzNyIEgwbzQuuxQ+ZeTkK4AHLKyHER8XopLlbHi5FZORqG7XjLSSTPzo+8lEeVtSTpbOY6nG1KksIArk8T2c+fQ4xjJ85xG2U/P3GonI+tVrPpbchAarjk=
Subject: Re: [3/3] 2.6.21-rc6: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Marcus Better <marcus@better.se>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org
In-Reply-To: <200704160823.39074.marcus@better.se>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <200704151826.33837.marcus@better.se> <1176678525.16909.3.camel@daplas>
	 <200704160823.39074.marcus@better.se>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 14:45:24 +0800
Message-Id: <1176705924.5129.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 08:23 +0200, Marcus Better wrote:
> > Just for clarification, do you suspend from VESA framebuffer console or
> > from VGA text console?
> 
> From VESA console.

Have you tried other combinations?

s2ram -m -p -f
s2ram -s -p -f

Tony


