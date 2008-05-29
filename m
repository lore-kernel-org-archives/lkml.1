Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYE2U3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYE2U3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYE2U3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:29:05 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:36802 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758620AbYE2U3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:29:03 -0400
X-YMail-OSG: CcwzblkVM1nvnzKH47JKGsl9Wx9zbXt7NLdTr2RPPeVaocccbVgA6p8t1eCVzhEY6vfgHTvlp86VeVy7juPEn7a79tDs4DruaAsRGQrDLer6sNJxqaWpKEWtTeY-
X-RocketYMMF: rancidfat
Date: Thu, 29 May 2008 13:29:01 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: 2.6.24-rc4: mount.ntfs-3g hangs when smack is enabled
To: Miklos Szeredi <miklos@szeredi.hu>, lcapitulino@mandriva.com.br
Cc: casey@schaufler-ca.com, miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-Reply-To: <E1K1l3b-0008Rx-4i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <733291.96800.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Miklos Szeredi <miklos@szeredi.hu> wrote:

> >  I'm not sure whether this is a smack problem, but Mandriva users are
> > reporting that mount.ntfs-3g (ntfs driver, uses FUSE) hangs when
> > they try to mount their NTFS partition.
> 
> Yes, this is a smack/fuse interaction problem.  Also see this thread:
> 
>   http://marc.info/?l=fuse-devel&m=120931855107469&w=2
> 
> Casey, you were CC-d on the last mail in that thread.  Did you miss
> that?

Yup. Whiffed completely. Thank you for pointing it out.
 

Casey Schaufler
casey@schaufler-ca.com
