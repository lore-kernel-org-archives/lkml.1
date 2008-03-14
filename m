Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYCNTjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYCNTjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYCNTjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:39:13 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50385 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYCNTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:39:12 -0400
Message-ID: <47DAD39C.90405@indt.org.br>
Date: Fri, 14 Mar 2008 15:35:56 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] MMC: OMAP: Sync MMC OMAP driver with mainline tree
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:38:36.0274 (UTC) FILETIME=[FECD9520:01C8860A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre, Tony and folks,

The new version of the patch series that follows is a synchronization
of MMC OMAP driver from Linux-OMAP tree into mainline tree.

Improvements and corrections are based on comments from Pierre Ossman and 
Roel Kluin, from LKML.

Just to remind you, basically it brings MMC multislot support for OMAP boards 
with one slot (like H2 1611, H3 1710) or two slots (like H4 2420 and N800).
Others boards supported by such feature are: N770, Siemens SX1 and Apollon.

BR,

Carlos.

-- 
Carlos Eduardo Aguiar
Nokia Institute of Technology - INdT
Open Source Mobile Research Center - OSMRC - Manaus
Core Team
Phone: +55 92 2126-1079
Mobile: +55 92 8127-1797
E-mail: carlos.aguiar@indt.org.br

