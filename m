Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZJNE6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZJNE6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZJNE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:58:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZJNE6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:58:17 -0400
Message-ID: <4AD558A1.8020107@zytor.com>
Date: Tue, 13 Oct 2009 21:50:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Matt Helsley <matthltc@us.ibm.com>, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com> <4AD511F1.7010207@zytor.com> <20091014013936.GC27627@count0.beaverton.ibm.com> <4AD5365E.5090709@zytor.com> <20091014044035.GB32114@us.ibm.com>
In-Reply-To: <20091014044035.GB32114@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 09:40 PM, Sukadev Bhattiprolu wrote:
> H. Peter Anvin [hpa@zytor.com] wrote:
> | > 
> | > Except we can't use clone2() because it conflicts on ia64.  Care to propose
> | > a name you would prefer?
> 
> Yes, I am running out of ideas :-)
> 
> How about clone64_with_pids() ? - hope we don't need a 65th clone-flag :p

never_clone_alone()  ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

