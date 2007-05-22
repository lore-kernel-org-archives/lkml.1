Return-Path: <linux-kernel-owner+w=401wt.eu-S966449AbXEVQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966449AbXEVQGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965426AbXEVQGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:06:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:24481 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765789AbXEVQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fE7uwQDVophbwb74hjJoZYtgz3zu32qIO3dhfXpxZBA9JJUEG2mfN0LgfO7OwcFuUwzi1fLN40zxzuujQctoVA5SutHqAMQDfY+5M32Nx4DNMwZUSMrN7zeUwbd/RY1TBvpSuGW7CaRmsehRabtBHD5aNKInuW73g/t6ny4p+AI=
Message-ID: <9e4733910705220906l323f3b9dw5204e7db700b30a6@mail.gmail.com>
Date: Tue, 22 May 2007 12:06:11 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <4652A6F9.1040502@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <4652295E.7060305@garzik.org>
	 <21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>
	 <4652A6F9.1040502@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Someone just pinged me privately asking about virtualization support
for the console and graphics hardware. What's the plan for handling
virtualization?

-- 
Jon Smirl
jonsmirl@gmail.com
