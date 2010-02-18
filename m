Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0BRCyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:54:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:33741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab0BRCyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:54:00 -0500
Message-ID: <4B7CAAC8.1010303@kernel.org>
Date: Wed, 17 Feb 2010 18:49:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 0/3] radix tree spareirq addon cleanup
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org> <m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>
In-Reply-To: <4B7CA9A1.3020806@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suggested by Eric.

third one will change overall the all arch...

Thanks

Yinghai Lu
