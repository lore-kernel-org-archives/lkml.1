Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbZJSQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbZJSQGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbZJSQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:06:19 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:33315 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbZJSQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:06:19 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 12:06:18 EDT
Message-ID: <4ADC8D44.9000804@anirban.org>
Date: Mon, 19 Oct 2009 09:01:08 -0700
From: Anirban Sinha <ani@anirban.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: Kernel oops when clearing bgp neighbor info with TCP MD5SUM enabled
References: <Pine.LNX.4.64.0910081514050.18315@sleet.zeugmasystems.local> <20091008.155429.02850661.davem@davemloft.net> <Pine.LNX.4.64.0910081622400.18315@sleet.zeugmasystems.local> <20091008.175703.83006470.davem@davemloft.net> <Pine.LNX.4.64.0910171035340.2364@sleet.zeugmasystems.local> <4ADA7EDC.5010402@anirban.org> <4ADB7856.7000803@anirban.org> <20091019121327.GA11423@redhat.com> <4ADC8677.7000607@anirban.org> <20091019153618.GA20967@redhat.com>
In-Reply-To: <20091019153618.GA20967@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I meant: yes sure it _is legal_ to schedule a work from within a timer
> callback (in fact it is legal from any context).

ok, then that part of the function looks fine.

Ani
