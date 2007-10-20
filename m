Return-Path: <linux-kernel-owner+w=401wt.eu-S1765443AbXJTLc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765443AbXJTLc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbXJTLcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:32:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36195 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764154AbXJTLcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=G53qH3CtlupoG64Qg0eqzrEePoFUch8KBDcOY4fnjs647cyfIH3L95Ct6N0aDtTnWTWvwD/9jxyZKawFGw07bfNAlHpFsPh1PCM2K87kY4lIsjlGN/cbEfvu/VoWYVAWEBsD7NmYQAeV3CBEIYgQK760NzS1nsTemtjOe6RDvwc=
Message-ID: <3d8471ca0710200432h3607b0a0i9169884ebec3b940@mail.gmail.com>
Date: Sat, 20 Oct 2007 13:32:06 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: PROBLEM: oops, Linus tree: 2.6.23-g4fa4d23f, BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
Cc: "Dave Haywood" <tla@oak.selfip.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Pavel Emelyanov" <xemul@openvz.org>
In-Reply-To: <Pine.LNX.4.64.0710201246540.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4719B727.7090908@oak.selfip.net>
	 <Pine.LNX.4.64.0710201246540.18815@twin.jikos.cz>
X-Google-Sender-Auth: c84ad9257f4e52f4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004

This should be fixed in recent git by
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9b013e05e0289c190a53d78ca029e2f21c0e4485

HTH.

-- 
Guillaume
