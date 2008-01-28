Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbYA1TJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbYA1TJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761901AbYA1TJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:25 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62209 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761870AbYA1TJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:24 -0500
Message-ID: <479E27D5.4010300@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:01 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] MMC: OMAP: Sync MMC OMAP driver with mainline tree
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:08:46.0836 (UTC) FILETIME=[35368340:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre, Tony and folks,

The patch series that follows is a synchronization of MMC OMAP driver
from Linux-OMAP tree into mainline tree.

Basically, it brings MMC multislot support for OMAP boards with one slot
(like H2 1611, H3 1710) or two slots (like H4 2420 and N800). Others
boards supported by such feature are: N770, Siemens SX1 and Apollon.

Improvements, fixes for some specific issues, code clean-ups and all are
included.

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

