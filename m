Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbYCETDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbYCETDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYCETDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:03:37 -0500
Received: from smtp.nokia.com ([192.100.122.233]:34474 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbYCETDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:03:36 -0500
Message-ID: <47CEEDB4.3030806@indt.org.br>
Date: Wed, 05 Mar 2008 15:00:04 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] MMC: OMAP: Include missing from previous merging
References: <479E27DA.8090804@indt.org.br> <20080207182117.014cfb15@poseidon.drzeus.cx>
In-Reply-To: <20080207182117.014cfb15@poseidon.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2008 19:02:43.0672 (UTC) FILETIME=[7E08D580:01C87EF3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Pierre Ossman wrote:
> On Mon, 28 Jan 2008 15:07:06 -0400
> Carlos Aguiar <carlos.aguiar@indt.org.br> wrote:
>
>   
>> From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
>>
>> This patch adds an include missing from previous merging
>> mainline tree into linux-omap tree.
>>
>> Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
>> Signed-off-by: Tony Lindgren <tony@atomide.com>
>> ---
>>     
>
> NAK. This header should not be needed in host drivers. It's a clear sign you're doing something bad.
>
> Rgds
>   
Hi Pierre and folks,

First of all, sorry the delay of this response, I was on vacation for
some weeks.

So, regarding the comments (thanks for all o them) in fact this missing
include is really not needed. So, this patch will be disconsidered when
I resent the series with corrections and comments suggested here.

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

