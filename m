Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYG3AA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYG3AA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYG3AAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:00:19 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57948 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYG3AAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:00:18 -0400
Message-ID: <488FAFA6.4070300@keyaccess.nl>
Date: Wed, 30 Jul 2008 02:02:46 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Pete Clements <clem@clem.clem-digital.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.27-rc1 oops on boot -- cs423x? (Corrected subject)
References: <200807292052.m6TKq1J3005288@clem.clem-digital.net>
In-Reply-To: <200807292052.m6TKq1J3005288@clem.clem-digital.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-07-08 22:52, Pete Clements wrote:

> [Previously sent with wrong subject line (2.6.26-rc1...) applicable
> to post 2.6.26 series]
> 
> Missed most of the 26-git series, git6 first one tried and oops 
> showed in that one as well as those tried after. oops below.

http://marc.info/?l=linux-kernel&m=121736480005656&w=2

For now just adding a CC as I'm off to bed. Note -- snd-cs4236 has been 
one of the most tested drivers with the new PNP code.

Rene.


