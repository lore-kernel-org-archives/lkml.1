Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYI0R3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYI0R3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYI0R3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:29:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:27909 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYI0R25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=uxh0ExeGJPpt7pNYkCbFNDVeQN16XKdbee/tnD0na2aQjT5kMTYzD5KvQ0Xo7fZGLJ
         IGlJo+eQoRuRMuTeynb2yjNO86/rKSPk1qcqltlimZlOKAt0TA7sxsP/qRGo5G8NDMIu
         Y/7v4r/HPy/8scKYpjw/9E0WwlHxyMVhpQFnI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-cd: fix another NULL ptr in debug statement
Date: Sat, 27 Sep 2008 18:27:20 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080925075133.GC13100@gollum.tnic>
In-Reply-To: <20080925075133.GC13100@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271827.21023.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's another null ptr fix in the debugging code. I'll be auditing all the
> debug fragments in case I've missed some.

also merged into the original patch
