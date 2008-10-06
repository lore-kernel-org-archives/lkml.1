Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYJFFvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYJFFvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYJFFvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:51:47 -0400
Received: from ptb-relay03.plus.net ([212.159.14.147]:46293 "EHLO
	ptb-relay03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJFFvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:51:46 -0400
Message-ID: <48E9A780.9090406@yahoo.com>
Date: Mon, 06 Oct 2008 06:52:00 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, IvDoorn@gmail.com,
       hmh@hmh.eng.br, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081005110226.GB4087@srcf.ucam.org> <20081005212432.GC11576@amd.corenet.prv> <20081005213330.GA11355@srcf.ucam.org>
In-Reply-To: <20081005213330.GA11355@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 41750ef29ac598c930658b81fe1ec7c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sun, Oct 05, 2008 at 05:24:39PM -0400, Dmitry Torokhov wrote:
> 
>> I'd rather have something like below. It should probably go through
>> David's (networking) tree. since it is in net/.
> 
> Fine with me, as long as Sitsofe can confirm it works?

Dmitry's patch also works for me.

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>


-- 
Sitsofe | http://sucs.org/~sits/
