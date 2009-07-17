Return-Path: <linux-kernel-owner+w=401wt.eu-S964922AbZGQRic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922AbZGQRic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbZGQRib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:38:31 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:48243 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933479AbZGQRib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:38:31 -0400
Message-ID: <4A60B70C.7030104@mnementh.co.uk>
Date: Fri, 17 Jul 2009 18:38:20 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>, Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> <aec7e5c30907170719re0b4152y987d30f8cdeb0cba@mail.gmail.com> <Pine.LNX.4.64.0907171626330.4731@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907171626330.4731@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> (forgot the "[PATCH]" marker on submission, re-added now)
> 
> On Fri, 17 Jul 2009, Magnus Damm wrote:
> 
>> On Fri, Jul 17, 2009 at 8:10 PM, Guennadi
>> Liakhovetski<g.liakhovetski@gmx.de> wrote:
>>> Add support for tmio_mmc hardware configurations, that lack the cnf io
>>> area, like SuperH SoCs. With this patch such hardware can pass a single
>>> ctl io area with the platform data.
>> Right, this need looks familiar. =)
> 
> Your Acked-by would be appreciated:-)

Im away tihs weekend - I'll have a look next week when I return.

:-)
