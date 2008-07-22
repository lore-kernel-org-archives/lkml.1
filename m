Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYGVNRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYGVNRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYGVNQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:16:54 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:26863 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGVNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=i7Zu0MxrMFmJLxzf9bYZ/yMDwYzncCUTgNF6HbUqUVJel1STOHAndqMH3KV7yxUzoh
         m2XrNqE2S08fxTyrkKBoO9UbEt8HYeGXcBzYTXbTz5f91NoL5e5krZJnNUuqCjqsJ5D8
         NcX5R5e9zHMUCKFLRV+LZw9SKrjW2BVLq+MEw=
Message-ID: <4885DDC4.2060609@googlemail.com>
Date: Tue, 22 Jul 2008 14:16:52 +0100
From: Johannes Engel <jcnengel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.12) Gecko/20071114 SUSE/2.0.0.12-34.1 Lightning/0.8 Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for
 iwl4965
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com> <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
In-Reply-To: <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefanik Gábor wrote:
> What is the status of this patch? Did it get lost? Was it rejected? I
> didn't get any answer on it, and I can't see it in iwlwifi-2.6.git or
> wireless-testing.git.

Actually it is at least in linux-next since 30th of June as of commit 
914233d68f07d5d9c22630cd5a84fdfd98f39da2.

Cheers, Johannes
