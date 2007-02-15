Return-Path: <linux-kernel-owner+w=401wt.eu-S1030517AbXBOSni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517AbXBOSni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030518AbXBOSni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:43:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:17850 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030517AbXBOSnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:43:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZoTt54hGCyrXiF/yfQSFWQ8mUlcI6HBUR51zSid+NaBew7hNBvidg5JIRPc2x2wxhKo7L/r8RxFi4c+/bW3HG4WJnZ9vATVLHtO3B+Bwrpbci4OFmggJzzOCeYrz3E1+Jm0pNu1YKqXKSa+f+PwQ66M1yVIfOHuy21u+w+u8WPA=
Message-ID: <75b66ecd0702151043q1c4638f7j823c682ad326da2e@mail.gmail.com>
Date: Thu, 15 Feb 2007 13:43:32 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Brian D. McGrew" <brian@visionpro.com>
Subject: Re: FW: UI getting "killed" randomely on Fedora machines
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <14CFC56C96D8554AA0B8969DB825FEA001C3A3F3@chicken.machinevisionproducts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <14CFC56C96D8554AA0B8969DB825FEA001C3A3F3@chicken.machinevisionproducts.com>
X-Google-Sender-Auth: 335765e3d35f80a7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Brian D. McGrew <brian@visionpro.com> wrote:
> Good morning all,
>
> We're seeing a problem where an application is being killed from what
> appears to be an out of memory issue.  Can anyone offer any insight on
> this for me?
>

See Documentation/vm/overcommit-accounting.

Lee
