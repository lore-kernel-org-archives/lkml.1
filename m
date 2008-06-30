Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbYF3Qcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbYF3Qcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYF3Qcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:32:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYF3Qcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:32:47 -0400
Message-ID: <48690A79.5030805@zytor.com>
Date: Mon, 30 Jun 2008 09:31:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH 25/39] merge common parts of uaccess.
References: <1214602486-17080-18-git-send-email-gcosta@redhat.com> <1214602486-17080-19-git-send-email-gcosta@redhat.com> <1214602486-17080-20-git-send-email-gcosta@redhat.com> <1214602486-17080-21-git-send-email-gcosta@redhat.com> <1214602486-17080-22-git-send-email-gcosta@redhat.com> <1214602486-17080-23-git-send-email-gcosta@redhat.com> <1214602486-17080-24-git-send-email-gcosta@redhat.com> <1214602486-17080-25-git-send-email-gcosta@redhat.com> <1214602486-17080-26-git-send-email-gcosta@redhat.com> <20080630063030.GA31336@elte.hu> <20080630063155.GA2915@elte.hu>
In-Reply-To: <20080630063155.GA2915@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> there was another merge fallout as well, when i merged it into 
> tip/master - see below.
> 
> 	Ingo
> 

This was actually in the original patch, but I had to remove it when 
applying it on top of auto-x86-next.

	-hpa
