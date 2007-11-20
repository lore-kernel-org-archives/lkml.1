Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbXKTQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbXKTQnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXKTQnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:43:32 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55915 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXKTQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:43:31 -0500
Message-ID: <47430D86.3070801@bull.net>
Date: Tue, 20 Nov 2007 17:38:30 +0100
From: Jean noel Cordenner <jean-noel.cordenner@bull.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: cmm@us.ibm.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]  i_version update - vfs part
References: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>	 <1193331870.5487.31.camel@frecb002711.frec.bull.fr> <1193346351.4288.16.camel@localhost.localdomain>
In-Reply-To: <1193346351.4288.16.camel@localhost.localdomain>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/11/2007 17:50:41,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/11/2007 17:50:41,
	Serialize complete at 20/11/2007 17:50:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here you can find some performance comparison in terms of CPU 
utilization and transactions per second (using FFSB) on ext4 filesystem 
with and without i_version option.

http://bullopensource.org/ext4/20071116/ffsb-write.html

regards,
Jean noel
