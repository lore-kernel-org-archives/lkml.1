Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYIBQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYIBQlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIBQk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:40:57 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:7818 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYIBQk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:40:56 -0400
Message-ID: <48BD6C8E.5060704@hp.com>
Date: Tue, 02 Sep 2008 09:40:46 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Stephen Hemminger <stephen.hemminger@vyatta.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, Dushan Tcholich <dusanc@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Robert Hancock <hancockr@shaw.ca>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, bridge@lists.linux-foundation.org
Subject: Re: [RFC] bridge: STP timer management range checking
References: <fa.wTMiBcGRgw2fBtdHwtX7y0lkc8s@ifi.uio.no>	<48975BD3.6040709@shaw.ca>	<a08621850808041337k1d1deb6fk78098d9fcd4930dd@mail.gmail.com>	<20080807185802.GA16327@electric-eye.fr.zoreil.com>	<a08621850808101200n220afd2dve58abe67830b7a4f@mail.gmail.com>	<a08621850808110053j5cbf23e6xdf52c9e7440abf19@mail.gmail.com>	<a08621850808291848q5660148fx57d576ecfcbfce8@mail.gmail.com>	<a08621850808310151o143845h195a8658d02270d9@mail.gmail.com>	<20080831100537.6929c51e@extreme> <20080831104309.780cc01f@extreme>	<20080831230247.76b5a193@lxorguk.ukuu.org.uk>	<48BB295A.6050200@vyatta.com> <20080901093827.24eec86f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080901093827.24eec86f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can one change the TCP maximum RTO to be smaller than specified in the 
specs?

rick jones
