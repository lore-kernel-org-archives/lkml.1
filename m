Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYHTK6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYHTK6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYHTK6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:58:25 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34326 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYHTK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:58:25 -0400
Message-ID: <48ABF880.5010605@s5r6.in-berlin.de>
Date: Wed, 20 Aug 2008 12:57:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kevin Diggs <kevdig@hypersurf.com>, linux-kernel@vger.kernel.org,
       david@fromorbit.com, arnd@arndb.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: {NOT a PATCH} Corrections please ...
References: <48AB73A3.9010404@hypersurf.com> <20080820095908.GC28492@elte.hu>
In-Reply-To: <20080820095908.GC28492@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Kevin Diggs <kevdig@hypersurf.com> wrote:
>> 	It was recommended that I use a completion in a driver I am 
>> working on.  While figuring out how to use one,

Kevin, as a side note:  LDD3 chapter 5 pages 114 ff has some guidance.
http://lwn.net/Kernel/LDD3/
I'm only pointing to it for the unlikely case that you didn't come
across LDD3 yet.  The dead tree version is affordable too, and more
comfortable to read than the online version.
-- 
Stefan Richter
-=====-==--- =--- =-=--
http://arcgraph.de/sr/
