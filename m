Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYIDIG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYIDIG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbYIDIFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:05:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:31151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYIDIFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=swAWKkvs00jXkOSjoNRlfC+T+JuABYak7VXBRuxyG07Ub0aIhjNy2TYjjhQhzH3dE/
         X5hnd8HY2jZnuOVp+boM6OFDxVRx9IXYVt076f5HAUdtF61D4IBxTAOY2aV6lEZKoLO0
         tvc1g8tweHBXVQVaIM7cHzG3xygPuauhBjz0k=
Message-ID: <38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:05:36 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
In-Reply-To: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ repost adding i2c mailing list in CC, sorry for that ]

On Thu, Sep 4, 2008 at 9:43 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm wondering why does this flag exist ?
>
> Why is a hw monitor device so special so that an I2C bus needs
> a flag to tell the rest of the world that it support it ?
>
> Thanks
> --
> Francis
>
