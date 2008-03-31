Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYCaWRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYCaWRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYCaWQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:16:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:9954 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYCaWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FHFX0UHL+dPChEVnI0hWM4C0fQp1iHsxcXWcGC2Dh8CsImB6lQFsB++Ww4ZjuT+Eiyu2gtBOQf/9RZU+VEHw1WPFxiXPmJs3mfd2o6VzitWlxwLeZbWnEnmY0sMavVbsVHd1xfQb69uPwDqJVvFi3g+o1eXyzYldGJTjNyr62m8=
Subject: Re: Sparse Question
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1207001278.6543.78.camel@brick>
References: <1206998108.6543.74.camel@brick>
	 <1206999598.6543.76.camel@brick> <20080331215835.GM9785@ZenIV.linux.org.uk>
	 <1207001278.6543.78.camel@brick>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 15:16:57 -0700
Message-Id: <1207001817.6543.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 15:07 -0700, Harvey Harrison wrote:
> Sorry, maybe I'm thick, but how does _IOC_TYPECHECK get pulled
> into the _IOC_NR use?
> 

Nevermind, I see it now, I was just hung up on the IOC_NR part.

Harvey

