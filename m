Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYDIT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYDIT5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYDIT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:57:25 -0400
Received: from saeurebad.de ([85.214.36.134]:59622 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbYDIT5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:57:25 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Andreas Grimm" <agrimm61@gmail.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: VM - a plenty of inactive memory
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	<874pabrx6b.fsf@saeurebad.de>
	<cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
	<2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
	<cf40c6a90804091108v522bd757nb81e9f97fdc132fc@mail.gmail.com>
Date: Wed, 09 Apr 2008 21:56:39 +0200
In-Reply-To: <cf40c6a90804091108v522bd757nb81e9f97fdc132fc@mail.gmail.com>
	(Andreas Grimm's message of "Wed, 9 Apr 2008 20:08:19 +0200")
Message-ID: <87myo2redk.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Andreas Grimm" <agrimm61@gmail.com> writes:

> Hi Kosaki,
>
>>  # echo 3 > /proc/sys/vm/drop_caches
>>
> that frees exactly the 1,5Gigs in the buffers and the cache. Inactive
> memory is still at 25GB.
> Any other hint?

Could you supply the rest of /proc/meminfo?

	Hannes
