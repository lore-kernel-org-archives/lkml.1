Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbYF2U14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbYF2U14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbYF2U1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:27:47 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:58815 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbYF2U1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HcX9q+aHNINvQLczJ2IdJC4zOBnL6X2QKiuIVvOcGs4ihDcv8H31PxFtwtTKwasDTx
         Y6oz4WKzOxvqpb6B8CBnZqXtZGdSkVN1tuhZjYh0CXKk+5wa8DwQtT3Nd0km4VFRd3bm
         ZOq4I3TPp36aJmQlyv8eoxqsmHv8Vrmnk3nvY=
Message-ID: <dd18b0c30806291327j7f94d4f3x27e7b3d97f97565c@mail.gmail.com>
Date: Sun, 29 Jun 2008 20:27:45 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Ray Lee" <ray@madrabbit.org>
Subject: Re: [Bug #10959] stuck tcp connections 2.6.26-rc7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <2c0942db0806291304t2f278e7fq65b67519eb56af41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.OtD.769ZIB@albercik>
	 <2c0942db0806291304t2f278e7fq65b67519eb56af41@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 8:04 PM, Ray Lee <ray@madrabbit.org> wrote:
> On Sun, Jun 29, 2008 at 11:18 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10959
>> Subject         : stuck tcp connections 2.6.26-rc7
>> Submitter       : Justin Mattock <justinmattock@gmail.com>
>> Date            : 2008-06-22 18:09 (8 days old)
>> References      : http://marc.info/?l=linux-kernel&m=121415821219644&w=4
>
> Last word on this was that it was traced down to a problem with
> madwifi / wpa_supplicant that was independent of kernel version
> (reverting to an earlier wpa_supplicant fixed the problem), so I think
> this can be closed.
>

Yes; That was the case with me, I'm not too sure about the other
reports. But from over here I'm a yes too closing.
regards;

-- 
Justin P. Mattock
