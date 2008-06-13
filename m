Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbYFMR4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbYFMR4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYFMR4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:56:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:29502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFMR4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=VkBa4Fypj9nnTij6nydPUGKeIRaActpD+dqOwdqVIeIj6KzQxWTrtAhsFp8MMFcMhu
         MO+aPEAyZL2QaS8l3T/9Aajv0iXTlg5Aj86o8dq4lBGsgnf0ClLNp5yOSpTRnjfob2Dk
         +IZzzG28noXt21tFFnTisiK5IF02n4mmGxOuw=
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug #10821] rt25xx: lock dependancy warning, association failure, and kmalloc corruption
Date: Fri, 13 Jun 2008 20:09:57 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       bugme-daemon@bugzilla.kernel.org
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.pGD.22vSIB@albercik> <20080613140037.GC21341@cs181133002.pp.htv.fi>
In-Reply-To: <20080613140037.GC21341@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806132009.58612.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008, Adrian Bunk wrote:
> On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> >...
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
> > Subject		: rt25xx: lock dependancy warning, association failure, and kmalloc corruption
> > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > Date		: 2008-05-29 14:30 (10 days old)
> 
> 
> Ivo, can you look at this 2.6.26-rc regression?

Sure, both issues should have been fixed in 2.6.26-rc5 :)

Ivo
