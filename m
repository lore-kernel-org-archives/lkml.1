Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472Ab0AECVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0AECVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256Ab0AECVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:21:51 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:59290 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0AECVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gSVo2sRWYlKZ9tb1xEL7qiGxrWSzjhv+5sYbUB75sWmi7OgOjexM+8C47fS9QODoLh
         0ucJCSwyi2Kl20yJcEmNCBJ48RUKli8wPrTJw5+hVJpuK0pgmvwHAVFfRMirhnq7UamJ
         CWaLylGb6PQSxVCcFoBIaBgCEG7PxAXObR5HE=
Message-ID: <4B42A23B.4080704@gmail.com>
Date: Mon, 04 Jan 2010 20:21:47 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Scott Davilla <davilla@4pi.com>, Naren Sankar <nsankar@broadcom.com>,
       Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
References: <20100104230227.GA14314@redhat.com> <20100104231949.GA14496@kroah.com> <4B427AF5.2030805@redhat.com>
In-Reply-To: <4B427AF5.2030805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 05:34 PM, Jarod Wilson wrote:
> On 1/4/10 6:19 PM, Greg KH wrote:
>> On Mon, Jan 04, 2010 at 06:02:27PM -0500, Jarod Wilson wrote:
>>> This patch supersedes the earlier ones sent by Manu Abraham to add
>>> the Broadcom Crystal HD driver to the staging tree, per discussion
>>> with him about it. I've been working with Broadcom's Naren Sankar
>>> on this driver for a number of months, and had already talked Naren
>>> about submitting this on Broadcom's behalf, didn't expect anyone
>>> else to jump on submitting it as quickly as Manu did. ;)
>>
>> Looks good, I'll queue it up tomorrow.
>
> Nb: it looks like the thing is so massive (~935k), its not showing up on
> lkml (at least, not in a timely fashion), so for the interested:
>
> <http://people.redhat.com/jwilson/misc/broadcom-crystalhd-decoder-driver-staging.patch>
>
> Thanks much!

Literally the majority of the code is #defines for what looks like 
register bits, etc - is all that really necessary?
