Return-Path: <linux-kernel-owner+w=401wt.eu-S966634AbXEVRyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966634AbXEVRyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966555AbXEVRyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:54:20 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:55504 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966542AbXEVRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:54:19 -0400
Message-ID: <46532E49.6020402@s5r6.in-berlin.de>
Date: Tue, 22 May 2007 19:54:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>, Adrian Bunk <bunk@stusta.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>	 <46503542.50300@s5r6.in-berlin.de>	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>	 <46504876.9040802@s5r6.in-berlin.de>	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>	 <46505DBD.5010005@s5r6.in-berlin.de>	 <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>	 <46532247.6030803@s5r6.in-berlin.de>	 <a781481a0705221013m45f82054tca9a9a78ea8935d4@mail.gmail.com>	 <46532AA4.6080501@s5r6.in-berlin.de> <a781481a0705221046p6d94a652k3081eacdba01ca8d@mail.gmail.com>
In-Reply-To: <a781481a0705221046p6d94a652k3081eacdba01ca8d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> When I said "The standard and maintainable way (for drivers at least)
>> is..." I didn't mean the example expression, I meant the *direction* in
>> which the example was stating dependencies.
> 
> In that case I wish "the points" you make on threads are relevant to them.

My initial reply was on a patch which removed the A-to-B declaration of
dependency.
-- 
Stefan Richter
-=====-=-=== -=-= =-==-
http://arcgraph.de/sr/
