Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZKMVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZKMVv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZKMVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:51:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZKMVvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:51:20 -0500
Message-ID: <4AFDD4D3.4060909@zytor.com>
Date: Fri, 13 Nov 2009 13:51:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/3] setup: Store the boot cursor state
References: <1258142222-16092-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1258142222-16092-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 11:57 AM, Matthew Garrett wrote:
> Add a field to store the boot cursor state and implement this for VGA on
> x86. This can then be used to set the default policy for the boot console.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

I'm cool with this, but please update the appropriate files in
Documentation/x86 as well.

	-hpa
