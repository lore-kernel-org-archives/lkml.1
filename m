Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZLMKMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZLMKMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 05:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZLMKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 05:12:40 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:41865 "HELO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751936AbZLMKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 05:12:39 -0500
Message-ID: <4B24BE17.805@pardus.org.tr>
Date: Sun, 13 Dec 2009 12:12:39 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr> <4B24856A.4020507@goop.org>
In-Reply-To: <4B24856A.4020507@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
> Why are you running a 32-bit kernel on this machine?  Sounds like a
> bad mismatch.
>
>     J

Hmm, that's because we're using/developing a Linux distribution which
doesn't have 64-bit support yet. But since the guest will be a
compile-farm for our needs, it's worth trying to run an 64-bit distro on
the host to see the difference, thanks for the tip but how much should
this affect the performance?

Thanks.
