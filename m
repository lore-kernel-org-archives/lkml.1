Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbZF3A1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbZF3A1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZF3A1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:27:31 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:36300 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZF3A1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RlMNMHimxrYWnKw835XVZ+yFx0cjEMVVrWQtO15CCbOz4KFdfVcoS8CQjerGXO4ssh
         zX/1aWN6Ssok2Tf1Y/7kCcCK2QKD4Mj+3udSa+K87D0PM12r+0cAvehsB9C2Tipj3Dl7
         KnY/oNSurVrN/nr27XIAm7kLfixYBbRcosnKo=
Message-ID: <4A495C2D.1040706@gmail.com>
Date: Mon, 29 Jun 2009 18:28:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christof Warlich <christof@warlich.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name>
In-Reply-To: <4A48C799.2010102@warlich.name>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 07:54 AM, Christof Warlich wrote:
> Robert Hancock schrieb:
>> Are there any errors from libata, etc. showing up before all of the
>> filesystem errors?
> No, nothing else, just the filesystem errors. Would it make sense to
> switch on any
> type of debugging?

Hmm.. How about any normal output from the libata, scsi, etc? Seems odd 
you wouldn't get anything unusual there if the file system was complaining..
