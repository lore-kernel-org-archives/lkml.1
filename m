Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYIDIEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYIDIEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYIDIET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:04:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:31045 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYIDIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wIi8qOEpAEeR5H4d4a+O68rV06qxlwFx/es7P3qQkyNLlUmsoT1EtAmnsxCG9R076h
         0/ZYjNrG5POh1/K6cRzwgFrvwHjExxhqikoPAEb5V+5YTkAt6qwAXK+1XVcOLe+3mYVk
         Btj1pkUB1NE/ZmeLCYkfnF4ds6lm8NE3Ng+8I=
Message-ID: <38b2ab8a0809040104v58bd2d4t8435fd9707ec7d72@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:04:14 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080904095829.76a5c3ed@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	 <20080904095829.76a5c3ed@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

On Thu, Sep 4, 2008 at 9:58 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Dear Francis,
>
> On Thu, 4 Sep 2008 09:43:10 +0200, Francis Moreau wrote:
>> I'm wondering why does this flag exist ?
>>
>> Why is a hw monitor device so special so that an I2C bus needs
>> a flag to tell the rest of the world that it support it ?
>
> This is a question for the i2c mailing list.
>

you're right, I'm going to repost on the correct resort.

thanks
-- 
Francis
