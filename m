Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZFPSq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZFPSq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZFPSqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:46:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZFPSqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:46:19 -0400
Message-ID: <4A37E7DB.7030100@redhat.com>
Date: Tue, 16 Jun 2009 14:43:39 -0400
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ralf Gross <Ralf-Lists@ralfgross.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: io-scheduler tuning for better read/write ratio
References: <20090616154342.GA7043@p15145560.pureserver.info> <4A37CB2A.6010209@davidnewall.com> <20090616184027.GB7043@p15145560.pureserver.info>
In-Reply-To: <20090616184027.GB7043@p15145560.pureserver.info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 02:40 PM, Ralf Gross wrote:
> David Newall schrieb:
>> Ralf Gross wrote:
>>> write throughput is much higher than the read throughput (40 MB/s
>>> read, 90 MB/s write).
> 
> Hm, but I get higher read throughput (160-200 MB/s) if I don't write
> to the device at the same time.
> 
> Ralf

How specifically are you testing? It could depend a lot on the particular access patterns you're using to test.

--CJD
