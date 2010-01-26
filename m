Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558Ab0AZUQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab0AZUQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012Ab0AZUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:16:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:44649 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751120Ab0AZUQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:16:54 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18U2h13MQYUMkhRvBhn7KrlvJgoqm2DQXK3MfJv6j
	RoAfTUopmId9yL
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: typo in ./crypto/Kconfig
Date: Tue, 26 Jan 2010 21:02:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32.6; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001262102.15946.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

line 819 lacks an "e":

"ANSI X9.31 A.2.4. Not this option must be enabled if CRYPTO_FIPS" 

, isn't it ? 

-- 
MfG/Sincerely
Toralf Förster
