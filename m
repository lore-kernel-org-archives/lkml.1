Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYIPXwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYIPXwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYIPXwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:52:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYIPXwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:52:45 -0400
Message-ID: <48D046C0.6050607@manoweb.com>
Date: Tue, 16 Sep 2008 16:52:32 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
References: <48CEC71F.3000006@manoweb.com>	 <20080916093513.GF1916@fluff.org.uk>  <48CFEF3F.5040901@manoweb.com>	 <1221604022.3598.4.camel@moss.renham>  <48D03811.9070805@manoweb.com> <1221606290.3598.41.camel@moss.renham>
In-Reply-To: <1221606290.3598.41.camel@moss.renham>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18p/NTeulrF66s8B06KEjt/DK/XQoB4Z4OY61l
 2HJ0DT4Q1CQOjmJ6o6ayouZHriYsZSyomi0C0X4PthVg0Tu8eh
 fMo2m6xvbKeM6YsjoXEPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:

> Generally the genalloc pool will be set up exactly once, at boot, by the
> platform code.  Then yes indeed the pool can be exported for driver use.


Oh thanks now it's clear.

bye
as

