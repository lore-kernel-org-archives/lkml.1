Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZKMWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZKMWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZKMWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:16:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbZKMWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:16:52 -0500
Message-ID: <4AFDDAD3.5080307@zytor.com>
Date: Fri, 13 Nov 2009 14:16:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/3] setup: Store the boot cursor state
References: <1258142222-16092-1-git-send-email-mjg@redhat.com> <4AFDD4D3.4060909@zytor.com> <20091113220220.GA7233@srcf.ucam.org>
In-Reply-To: <20091113220220.GA7233@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 02:02 PM, Matthew Garrett wrote:
> On Fri, Nov 13, 2009 at 01:51:15PM -0800, H. Peter Anvin wrote:
> 
>> I'm cool with this, but please update the appropriate files in
>> Documentation/x86 as well.
> 
> It's in screen_info rather than the zero page - is there any relevant 
> documentation to update?
> 

Hm, looks like there isn't... although it would be rather good to get
screen_info and the other substructures documented!

	-hpa



