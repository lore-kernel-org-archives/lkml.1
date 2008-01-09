Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYAIRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYAIRzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAIRyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:54:52 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:61180 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYAIRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=q/oxV0k3GGGrcJExfTB7sdH27H/ibBUwEIjTRxw+h4ArmRmRAVbsXOOEkvtfXzlTK5s7KHOIRlU++u2XryQE+wkM34wQMDZUbfz85c4W8Mh9CaK+nB3ouQY7BBhkALeDcD32qp0yl+uwPvHwytxuCdAT0eZFPmmESQt53Tn/Jqg=
Message-ID: <47850A23.5030408@gmail.com>
Date: Wed, 09 Jan 2008 15:53:39 -0200
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com> <Pine.LNX.4.64.0801091509280.25041@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0801091509280.25041@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> thanks a lot for the detailed and accurate report. Yes, this device would 
> require a mapping quirk for the non-working keys. The endlessly repeating 
> key might need something more sophisticated. I will look into your report 
> and send you a patch to test in a few days. Currently, I am overloaded 
> with other things, sorry.

   Thanks, I'm at your disposal for any additional information you might 
need.

Adolfo
