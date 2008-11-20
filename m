Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYKTIgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYKTIgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYKTIgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:36:11 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:54191 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYKTIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:36:10 -0500
Message-ID: <49252174.7080709@fr.ibm.com>
Date: Thu, 20 Nov 2008 09:36:04 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Kirill Korotaev <dev@openvz.org>, Pavel Emelianov <xemul@openvz.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: Re: CLONE_NEWIPC documentation
References: <4924651C.4080909@gmail.com> <m163mji4cz.fsf@frodo.ebiederm.org>
In-Reply-To: <m163mji4cz.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Michael Kerrisk <mtk.manpages@googlemail.com> writes:
> 
>> Kirill, Pavel,
>>
>> Below is a patch to document the CLONE_NEWIPC flag that was
>> added in 2.6.19.
>>
>> Could you please review and let me know of improvements
>> or inaccuracies?

I would also add that an interesting effect of the sysvipc namespace is
the automatic cleanup of sysvipc objects when the namespace is destroyed.

Thanks 

C.
