Return-Path: <linux-kernel-owner+w=401wt.eu-S932761AbZHDKBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbZHDKBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbZHDKBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:01:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708AbZHDKBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:01:12 -0400
Message-ID: <4A780828.4090203@redhat.com>
Date: Tue, 04 Aug 2009 13:06:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, davidel@xmailserver.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
References: <20090803151426.GA3630@redhat.com> <4A770260.5000507@redhat.com> <20090803165708.GB3630@redhat.com> <4A77F6EF.8010002@redhat.com> <20090804085406.GA3311@redhat.com> <4A77FCB8.1000205@redhat.com> <20090804091755.GD4764@redhat.com> <4A77FE9D.3020505@redhat.com> <20090804092342.GE4764@redhat.com> <4A77FFB5.4060201@redhat.com> <20090804092621.GB3185@redhat.com>
In-Reply-To: <20090804092621.GB3185@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 12:26 PM, Michael S. Tsirkin wrote:
> How is it an exception? It seems that one reader get the counter,
> others will block until the next write.
>    

Right.  I retract my comments....

-- 
error compiling committee.c: too many arguments to function

