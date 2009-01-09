Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZAISh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZAISh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZAIShN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:37:13 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5244 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZAIShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:37:12 -0500
Message-ID: <496798D9.3030507@caviumnetworks.com>
Date: Fri, 09 Jan 2009 10:35:05 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Dick Hollenbeck <dick@softplc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: New true IDE compact flash driver starting point?
References: <49659E41.5070001@softplc.com>
In-Reply-To: <49659E41.5070001@softplc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2009 18:35:05.0854 (UTC) FILETIME=[FDF461E0:01C97288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dick Hollenbeck wrote:
> On a new ARM9 board with memory mapped interface to a compact flash 
> socket, I need to implement an IDE or ATA driver that will support TRUE 
> IDE mode.
> 
> Am using kernel version 2.6.26
> 
> What is the best starting point, i.e. example driver in the tree?
> 
> 
> Please respond to my personal email address also as I do not subscribe.
> 

Not that it is a piece of art, but this is my implementation of a 
similar driver that I am trying to get merged.

http://marc.info/?l=linux-ide&m=122895233817240&w=4

David Daney
