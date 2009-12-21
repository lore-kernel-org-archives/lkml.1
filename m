Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZLUTMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZLUTMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbZLUTML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:12:11 -0500
Received: from smtp110.rog.mail.re2.yahoo.com ([206.190.37.120]:25582 "HELO
	smtp110.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757033AbZLUTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:12:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=IQaGu/32kra24NgQymsYcJgssjGKKs9JPHD8owGs0ZOIkc2/sRVxIAH+28YGteB0HSgQl297/bPzacbi/977SJ7VB6Tp5AUwLJDCguXVIWDE9ZFem3SmeSaZDXL4S8NVtmq889ipIrQh4E9KbtwVKZ0VW0rC5eYzMSLCXy68D4g=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: .J5R9McVM1lF2HQanWe7dwVzfjYhh4Vf6i_n3atMlAFm9hbihX9t4CctdZufOfxIbQ--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc1] System timer flooding bus on Lenovo Thinkpad W500 laptop in x86_64
Date: Mon, 21 Dec 2009 14:12:03 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc1-custom-radeon; KDE/4.3.82; x86_64; svn-1062525; 2009-12-14)
References: <200912211312.52769.shawn.starr@rogers.com>
In-Reply-To: <200912211312.52769.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211412.03936.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 21, 2009 01:12:52 pm Shawn Starr wrote:
> Hello kernel devs,
> 
> I am noticing a serious problem with the system timer flooding the bus with
> many interrupts for no reason. I have compiled the kernel with tickless
> enabled.
> 
I should also note I have tried the following: disabling MSI, PAT and even 
disabling the Local APIC to see. 

Shawn.
