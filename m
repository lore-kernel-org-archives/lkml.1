Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZJNEkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZJNEkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZJNEj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:39:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40795 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZJNEj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:39:58 -0400
Date: Tue, 13 Oct 2009 21:40:35 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091014044035.GB32114@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD511F1.7010207@zytor.com> <20091014013936.GC27627@count0.beaverton.ibm.com> <4AD5365E.5090709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD5365E.5090709@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
| > 
| > Except we can't use clone2() because it conflicts on ia64.  Care to propose
| > a name you would prefer?

Yes, I am running out of ideas :-)

How about clone64_with_pids() ? - hope we don't need a 65th clone-flag :p
