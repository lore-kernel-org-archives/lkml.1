Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbYAHRNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbYAHRNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYAHRNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:13:15 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60854 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYAHRNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:13:14 -0500
Message-ID: <4783AEEF.6090704@s5r6.in-berlin.de>
Date: Tue, 08 Jan 2008 18:12:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Bryan Wu <cooloney.lkml@gmail.com>
CC: Michal Simek <simekm2@fel.cvut.cz>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu
Subject: Re: New linux arch
References: <47820D24.3060800@fel.cvut.cz> <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>
In-Reply-To: <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> On Jan 7, 2008 7:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
>> I checked whole code with checkpatch.pl script to avoid code violations.
>> I hope I resolve the most of coding style problems.
> 
> Yes, passing checkpatch.pl is required by LKML.

checkpatch.pl only gives guidance; it is not a hard requirement.  You
should have good reasons if you deviate from it though.

Also check with sparse (Documentation/sparse.txt).  And there is much
more you should have a look at before you send proposed patches, see
Documentation/SubmitChecklist.
-- 
Stefan Richter
-=====-==--- ---= -=---
http://arcgraph.de/sr/
