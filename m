Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYGVNKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYGVNKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYGVNKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:10:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYGVNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:10:34 -0400
Message-ID: <4885DC32.7090007@zytor.com>
Date: Tue, 22 Jul 2008 09:10:10 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	 <48848DDF.6010903@zytor.com>	 <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>	 <48851AC2.8030007@zytor.com> <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com>
In-Reply-To: <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> 
> Thanks for taking a  look at this. So well, it would be a
> misconfiguration bug by the distribution then to try to support a
> generic 686 kernel wihtout GENERIC then.
> 

Yes.

	-hpa
