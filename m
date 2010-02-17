Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab0BQDoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 22:44:55 -0500
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:44529 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933973Ab0BQDoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 22:44:54 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 756616.98578.bm@omp615.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=nNLGw9ob+XIYMVgQNSJsgjZJssCOGLMRrxEXLMXJidl+vK3vExGAaBgAZYOOTarQLKUReWgWUbaRdYjF7j/g6AEsxxV975SFfPEOcvkV2ANVjQjMzND8Dx83dC0HYD4WbV8S7CQ3N8Fpb4eguGjZe7FEl3omy4/k2JHoH2acy2w=;
Message-ID: <549084.45576.qm@web45206.mail.sp1.yahoo.com>
X-YMail-OSG: Ryt_w3UVM1nhmQDMje64Ng619X6DUnQ8GPDXTUje5JNErEGObqsZ5jXpF6XZ6WRu8PBKN9GHyTxnIK.3q8nkDeaUzmC.vocWASt8XqbsdzmK4WbwOXviBDDocOMlp.InfisvMCBGlPRxoeVYfCmmO2xMDQtS_eXpWBgt2qs7lw8z4_IS.TZYInghfScumRK18dluP2Wn_3iKV7QMD7IqjMOFBJDRRvinPVf_d6UiJHRy.6byE5HWEU8gaX5kfAn8qBs-
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Tue, 16 Feb 2010 19:44:53 -0800 (PST)
From: The Government <the_g0vernment@yahoo.com>
Subject: sata_mv driver support for Marvell Hercules II controller in newer kernels
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

I'm using a Supermicro aoc-sat2-mv8, which is supposedly supported by the Linux kernel by "sata_mv" driver. Unfortunately, I've been unable to troubleshoot why newer distros (and thus kernels) are not detecting/using sata_mv for this card. I tried an (older) Slackware 12.1 install disk, that for some reason works by use of sata_mv (12.1 was released may 2008, when I think sata_mv was still beta). Anyhow, I've tried many newest releases from Slackware, Arch, etc - and it seems newer kernels do not properly recognize this card. I'm not sure what to make of the newer kernels saying "adaptec aacraid driver" is being used (an incorrectly detected driver?). Anyway, I was told this chipset had great linux support - does it still? Thanks a lot.

(please CC me for replies, thanks a lot)


      

