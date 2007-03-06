Return-Path: <linux-kernel-owner+w=401wt.eu-S934014AbXCFKc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbXCFKc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbXCFKc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:32:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:2304 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014AbXCFKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Wf3Asv18+W3VyX6JyzMLWvUldtPeiloGHe2S7ig6+aroS5/T+KweMBXzyE7OEnT4hDgl8DYYzASHJi9OLn2S5Q2nA1Kn4giQsSvhtZyNzDRrCg/VwPjmtCUB23S9IoXlQmV3H8S/ZjPCq8dTmR12p1R8P8zPMA8BNF2gyoGkZqM=
Message-ID: <7783925d0703060232u61fdee44jb34f85a5e1538e72@mail.gmail.com>
Date: Tue, 6 Mar 2007 16:02:56 +0530
From: "Rick Brown" <rick.brown.3@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Makefile for module with multiple directories
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to compile a kernel module whose source is organized in a
directory hierarchy. For eg:

driver
   |---A
   |    |---1.c
   |    |---2.c
   |
   |---B
        |---3.c
        |---4.c

I want to compile a single module (.ko) out of these source files. Can
you please suggest me a Makefile?

Thanks,

Rick
