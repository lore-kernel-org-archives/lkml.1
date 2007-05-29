Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbXE2PwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbXE2PwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXE2PwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:52:16 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:39310 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751634AbXE2PwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:52:15 -0400
X-YMail-OSG: f.Lz9w0VM1kTJa4LnRYVKOT5Cx88.0C1RF12Ganl5eWAYItL0z.ZhaQVkVOVCsIrQ9bh3f3yUg--
X-RocketYMMF: rancidfat
Date: Tue, 29 May 2007 08:52:14 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
To: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200705291946.FDB72328.NtTGSNMP@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <671296.4187.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp> wrote:


> Conventional UNIX's access control can't restrict
> which path_to_file can link with which another_path_to_file
> because UNIX's access control is a label-based access control.

UNIX access control is attribute based, not label based. The
distinction may be hair splitting in the current context, but
could be significant later if the thread continues. 




Casey Schaufler
casey@schaufler-ca.com
