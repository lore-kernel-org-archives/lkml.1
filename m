Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZLODAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZLODAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759082AbZLODAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:00:44 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:33648 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038AbZLODAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:00:44 -0500
Date: Mon, 14 Dec 2009 22:00:25 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-15?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Useless thermal acpi driver ?
In-reply-to: <20091211094515.4b4872ef@werewolf.home>
Message-id: <alpine.LFD.2.00.0912142159540.9446@localhost.localdomain>
References: <20091209232608.25aed4ca@werewolf.home>
 <4B20483C.6090309@gmail.com>
 <alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>
 <20091211094515.4b4872ef@werewolf.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this DSDT returns a constant temperature, always:

            Method (_TMP, 0, NotSerialized)
            {
                Return (0x0BB8)
            }


so in this case, Linux is just reporting the (lack of) news:-)

cheers,
Len Brown, Intel Open Source Technology Center

