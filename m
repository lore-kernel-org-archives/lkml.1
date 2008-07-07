Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYGGQis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYGGQis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYGGQi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:38:29 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:38002 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbYGGQi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:38:28 -0400
Message-ID: <48724676.6010704@de.ibm.com>
Date: Mon, 07 Jul 2008 18:38:14 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?UTF-8?B?Qk0gRGV1dHNjaGxhbmQgUmVzZWFyY2ggJiBEZXZlbG9wbWVudA==?=
 =?UTF-8?B?IEdtYkggLyBWb3JzaXR6ZW5kZXIgZGVzIEF1ZnNpY2h0c3JhdHM6IE1hcnRpbiA=?=
 =?UTF-8?B?SmV0dGVyLEdlc2Now6RmdHNmw7xocnVuZzogSGVyYmVydCBLaXJjaGVyLFNpdHo=?=
 =?UTF-8?B?IGRlciBHZXNlbGxzY2hhZnQ6IELDtmJsaW5nZW4gLyBSZWdpc3RlcmdlcmljaHQ=?=
 =?UTF-8?B?OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQsIEhSQiAyNDMyOTQ=?=
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Ryan Hope <rmh3093@gmail.com>
CC: carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, benh@kernel.crashing.org,
       Zan Lynx <zlynx@acm.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com> <486E4FD8.4010102@acm.org>  <Pine.LNX.4.64.0807042112130.16912@blonde.site> <200807071806.11630.nickpiggin@yahoo.com.au>  <487239BE.8070505@de.ibm.com> <48f7fe350807070916v4b8292aerb0a6fd0f360c5b9b@mail.gmail.com>
In-Reply-To: <48f7fe350807070916v4b8292aerb0a6fd0f360c5b9b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Hope wrote:
> Have you tried running Xorg 1.4.99.905?
I guess you mean the xserver? See, we don't have PCI and thus don't 
have any graphics hardware - it's a server platform ;-).
