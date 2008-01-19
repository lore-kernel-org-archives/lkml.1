Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYASMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYASMin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 07:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYASMif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 07:38:35 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:49745 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYASMie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 07:38:34 -0500
Message-ID: <4791EE99.3030802@abinetworks.biz>
Date: Sat, 19 Jan 2008 13:35:37 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>
CC: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NFS EINVAL on open(... | O_TRUNC) on 2.6.23.9
References: <476CEC5E.9070002@abinetworks.biz> <838DE9A2-59B2-49FA-B3E8-89B26368B1CF@bluecamel.eml.cc> <476E47F5.4090807@abinetworks.biz> <20071225140431.9264970a.akpm@linux-foundation.org> <199BEBA7-E46E-4B1F-9D36-91BB43331B75@oracle.com>
In-Reply-To: <199BEBA7-E46E-4B1F-9D36-91BB43331B75@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chuck,

As you requested i have finally found out that the problem was 
introduced in 2.6.22 (2.6.21.7 works, after 2.6.21.7 theres 2.6.22)

I have also examined the changeslogs: 2.6.22 introduce a certain number 
of patches into NFS client. Many of them are yours and Trond's.

Pls can you help with this ?

TIA

Gianluca
