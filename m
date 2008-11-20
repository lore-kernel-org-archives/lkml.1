Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYKTM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYKTM0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYKTM0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:26:14 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:52104 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYKTM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:26:13 -0500
Message-ID: <4925575D.8060704@fr.ibm.com>
Date: Thu, 20 Nov 2008 13:26:05 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Kirill Korotaev <dev@openvz.org>, Pavel Emelianov <xemul@openvz.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: Re: CLONE_NEWIPC documentation
References: <4924651C.4080909@gmail.com> <m163mji4cz.fsf@frodo.ebiederm.org> <49252174.7080709@fr.ibm.com> <cfd18e0f0811200328g643c1bdq46a48bac3a1ea744@mail.gmail.com>
In-Reply-To: <cfd18e0f0811200328g643c1bdq46a48bac3a1ea744@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Cedric,
> 
> On Thu, Nov 20, 2008 at 3:36 AM, Cedric Le Goater <clg@fr.ibm.com> wrote:
>> Eric W. Biederman wrote:
>>> Michael Kerrisk <mtk.manpages@googlemail.com> writes:
>>>
>>>> Kirill, Pavel,
>>>>
>>>> Below is a patch to document the CLONE_NEWIPC flag that was
>>>> added in 2.6.19.
>>>>
>>>> Could you please review and let me know of improvements
>>>> or inaccuracies?
>> I would also add that an interesting effect of the sysvipc namespace is
>> the automatic cleanup of sysvipc objects when the namespace is destroyed.
> 
> And the namespace is destroyed, when the last proces in the namespace
> terminates, right?

exactly.

Thanks,

C.
