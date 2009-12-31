Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZLaSZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZLaSZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZLaSZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:25:04 -0500
Received: from mail.vyatta.com ([76.74.103.46]:53930 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZLaSZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:25:03 -0500
Date: Thu, 31 Dec 2009 10:24:41 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
Message-ID: <20091231102441.6e81598a@nehalam>
In-Reply-To: <4B3CE8CA.5050003@majjas.com>
References: <4B300A2A.8040305@gmail.com>
	<4B300E30.9090707@majjas.com>
	<4B3114E3.1070602@majjas.com>
	<4B329FA3.9090904@majjas.com>
	<20091223230102.4bb0100e.akpm@linux-foundation.org>
	<4B34E847.8010809@majjas.com>
	<20091225152200.1cf11dfe@nehalam>
	<4B3581C7.8000702@majjas.com>
	<20091226095723.7ac82b18@nehalam>
	<4B367409.5060202@majjas.com>
	<4B379378.4000102@majjas.com>
	<20091227102238.0df149f9@nehalam>
	<4B37B7E2.5070307@majjas.com>
	<20091229093023.3ad24786@nehalam>
	<4B3A5048.9090700@majjas.com>
	<20091229114938.1f4d1c5c@nehalam>
	<4B3AFFE8.3060409@majjas.com>
	<20091229235942.51bf733d@nehalam>
	<4B3B7488.6080503@majjas.com>
	<20091230101046.2816d545@nehalam>
	<4B3CE8CA.5050003@majjas.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have similar motherboards and ACPI is having issues with parsing
the tables, probably not related but see:

  http://bugzilla.kernel.org/show_bug.cgi?id=14954


-- 
