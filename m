Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXGVW4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXGVW4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbXGVW4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:56:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:49115 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbXGVW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZEKGCMkNt0/oKytea1WUuZ7XR+UKx8ukHTBay8KC+2IgHHcQND8z4dvQXO1DoaIS4cobvuK1LA/4m7DgYojlhrM+iqUg6P9NHVFG2agfMS50chbnvcpA757a9sAagQuOTWi2QU7t+lTqj+VeFjQSJ9RpxYIFyHdezvRshHyXJVA=
Subject: Re: [PATCH] Fix fbcon - 'map_override' defined but not used warning
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46A38486.70903@googlemail.com>
References: <46A38486.70903@googlemail.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 06:56:16 +0800
Message-Id: <1185144976.6370.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 18:23 +0200, Gabriel C wrote:
> Hi,
> 
> I got this warning on current git:
> 
> ...
> 
> drivers/video/console/fbcon.c:130: warning: 'map_override' defined but not used
> 
> ...
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Thanks.

Tony


