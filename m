Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZHYGHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZHYGHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZHYGHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbZHYGHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:07:07 -0400
Message-ID: <4A937FA4.6000907@redhat.com>
Date: Tue, 25 Aug 2009 09:07:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Haneef Syed <Haneef.Syed@lntinfotech.com>
CC: kvm-owner@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Subject: Re: IBM server-X3650 issue with kvm modules
References: <OFB13FCF1E.D85554FA-ON6525761D.00201C5A-6525761D.002108B9@lntinfotech.com>
In-Reply-To: <OFB13FCF1E.D85554FA-ON6525761D.00201C5A-6525761D.002108B9@lntinfotech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 09:00 AM, Haneef Syed wrote:
> when i run qemu utilities to install redhat or fedora guest on montavista
> host running in ibm server, i found that there is vmwrite error occurs on
> following
>
>    

You've already posted this before.  It's impossible for us to debug kvm 
interactions with the montavista kernel.  Please take it up with 
montavista's support.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

