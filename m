Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZJHQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZJHQtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZJHQtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZJHQtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:49:35 -0400
Message-ID: <4ACE168F.6000803@redhat.com>
Date: Thu, 08 Oct 2009 12:42:55 -0400
From: Rob Evers <revers@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Jing Huang <huangj@brocade.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, vravindr@brocade.com
Subject: Re: [PATCH 10/14] bfa: Brocade BFA FC SCSI driver (include1)
References: <200909240104.n8O14a08020626@swe58.brocade.com>
In-Reply-To: <200909240104.n8O14a08020626@swe58.brocade.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Why does the include directory here contain 125 files?  This seems 
irregular compared to other linux mass storage drivers.
