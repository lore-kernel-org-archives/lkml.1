Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbZHSUxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbZHSUxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZHSUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZHSUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:53:42 -0400
Message-ID: <4A8C6651.4000206@redhat.com>
Date: Wed, 19 Aug 2009 23:53:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: configfs/sysfs
References: <4A8971A8.2040102@gmail.com> <20090817150844.GA3307@elte.hu> <4A89B08A.4010103@gmail.com> <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com> <4A8AD678.7050609@redhat.com> <4A8B9B79.9050004@gmail.com> <4A8BA5AE.3030308@redhat.com> <1250706227.27590.156.camel@haakon2.linux-iscsi.org> <4A8C5CBB.10605@redhat.com> <20090819204821.GA27292@elte.hu>
In-Reply-To: <20090819204821.GA27292@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 11:48 PM, Ingo Molnar wrote:
>
> FYI, an example of such a syscall design and
> implementation has been merged upstream in the .31 merge
> window, see:
>
> <big snip>
>
>    

Exactly.  It's beautiful.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

