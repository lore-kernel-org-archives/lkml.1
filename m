Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXLDM7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXLDM7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXLDM64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:58:56 -0500
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:29818 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752908AbXLDM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:58:54 -0500
X-YMail-OSG: dE9RL6sVM1l_IGjQbR3jFsRtSnBHBpIl6wZeXAhaxoj_qrz3heUOU_VbE7rZgVXLeT2GDsFPGiUJkdO3lz3WeCNhng--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.158.1
Date: Tue, 4 Dec 2007 04:58:52 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: What is the unit of "nr_writeback"?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <662998.31825.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 forgive the stupid question. What is the unit of "nr_writeback"? One would usually assume a rate, but looking at the code I see it added together with nr_dirty and nr_unstable, somehow defeating the assumption.

Cheers
Martin
------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de


