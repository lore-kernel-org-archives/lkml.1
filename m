Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZJLJxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZJLJxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZJLJxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:53:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:57146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbZJLJxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:53:18 -0400
Message-ID: <4AD2FC60.8080705@kernel.org>
Date: Mon, 12 Oct 2009 18:52:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200910101513.51320.elendil@planet.nl> <4AD2DFA4.9000602@kernel.org> <200910121148.16439.elendil@planet.nl>
In-Reply-To: <200910121148.16439.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 09:52:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Monday 12 October 2009, Tejun Heo wrote:
>> Alexander, can you please attach full boot log and the output of
>> "lspci -nn"?  Also, how reproducible is the problem?  You already
>> answered to Frans' question but can you be more specific?
> 
> Full dmesg was made available earlier at:
> http://xx.vu/~ahuemer/dmesg_ahuemer_20090923

Does blacklisting i801_smbus make any difference?

-- 
tejun
