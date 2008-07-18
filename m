Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYGRLCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYGRLCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYGRLCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:02:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38598 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYGRLCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:02:09 -0400
Message-ID: <4880782F.7030405@firstfloor.org>
Date: Fri, 18 Jul 2008 13:02:07 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Marcin Obara <marcin_obara@users.sourceforge.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>	 <874p6nsft5.fsf@basil.nowhere.org> <ea8d860a0807180351q490deea1rdf61469057e79ac3@mail.gmail.com>
In-Reply-To: <ea8d860a0807180351q490deea1rdf61469057e79ac3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Obara wrote:
> 2008/7/18 Andi Kleen <andi@firstfloor.org>:
>> How about the save oops data in HECI code? Will that be posted
>> on top of this?
> 
> This question was mostly already answered in
> http://lkml.org/lkml/2007/12/11/166
> In addition current MEI driver is for current platforms (AMT 3, 4, 5)
> and have no AMT 1.0 legacy support.

Well it didn't answer the question. Are you planning to submit
code to store the oopses/kernel log based on this code or not?

-Andi


